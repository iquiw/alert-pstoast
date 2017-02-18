;;; alert-pstoast --- Alert style using PowerShell toast notification script  -*- lexical-binding: t -*-

;; Copyright (C) 2017 Iku Iwasa

;; Version: 0.0.0
;; Keywords: notification
;; Package-Requires: ((emacs "25.1") (alert "1.2"))

;;; Commentary:
;;; Code:

(require 'alert)
(require 'xml)

(defconst alert-pstoast-script-path
  (expand-file-name "toast.ps1" (file-name-directory load-file-name)))

(defun alert-pstoast--xml (title message)
  "Generate toast XML string with TITLE and MESSAGE."
  (with-temp-buffer
    (xml-print
     `((toast nil
              (visual nil
                      (binding ((template . "ToastText02"))
                               (text ((id . "1")) ,title)
                               (text ((id . "2")) ,message))))))
    (buffer-string)))

(defun alert-pstoast--run-script (xml)
  "Run toast notification PowerShell script with XML input."
  (let ((process (start-process "pstoast" nil "powershell"
                                "-ExecutionPolicy" "RemoteSigned"
                                "-File" alert-pstoast-script-path)))
    (set-process-sentinel process 'alert-pstoast--sentinel)
    (process-send-string process xml)
    (process-send-eof process)))

(defun alert-pstoast--sentinel (process status)
  "Show PowerShell script PROCESS STATUS."
  (message "pstoast: %s" status))

(defun alert-pstoast-notify (info)
  "Notify notification INFO by PowerShell script."
  (let ((xml (alert-pstoast--xml
              (plist-get info :title)
              (plist-get info :message))))
    (alert-pstoast--run-script xml)))

(alert-define-style 'pstoast :title "PowerShell toast notification script"
                    :notifier 'alert-pstoast-notify)

(provide 'alert-pstoast)
;;; alert-pstoast.el ends here
