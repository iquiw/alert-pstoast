;;; alert-pstoast --- Alert style using PowerShell toast notification script  -*- lexical-binding: t -*-

;; Copyright (C) 2017 Iku Iwasa

;; Version: 0.0.0
;; Keywords: notification
;; Package-Requires: ((emacs "25.1") (alert "1.2"))

;;; Commentary:
;;; Code:

(require 'alert)
(require 'xml)

(defgroup alert-pstoast nil
  "Alert style using PowerShell toast notification"
  :group 'alert)

(defcustom alert-pstoast-default-icon
  (concat data-directory
          "images/icons/hicolor/48x48/apps/emacs.png")
  "Filename of default icon to show for pstoast-alerts."
  :type 'string
  :group 'alert-pstoast)

(defconst alert-pstoast-script-path
  (expand-file-name "toast.ps1" (file-name-directory load-file-name)))

(defun alert-pstoast--xml (title message icon)
  "Generate toast XML string with TITLE and MESSAGE.
TITLE and ICON can be omitted by specifying `nil'."
  (with-temp-buffer
    (let ((tmpl (if icon
                    (if title "ToastImageAndText02" "ToastImageAndText01")
                  (if title "ToastText02" "ToastText01")))
          (body `((text ((id . ,(if title "2" "1"))) ,message)))
          (idx 1))
      (when title
        (push `(text ((id . "1")) ,title) body))
      (when icon
        (push `(image ((id . "1") (src . ,icon))) body))
      (xml-print
       `((toast nil
                (visual nil
                        (binding ((template . ,tmpl)) ,@body))))))
    (buffer-string)))

(defun alert-pstoast--run-script (xml)
  "Run toast notification PowerShell script with XML input."
  (let ((process (start-process "pstoast" "*alert-pstoast*" "powershell"
                                "-ExecutionPolicy" "RemoteSigned"
                                "-File" alert-pstoast-script-path)))
    (set-process-coding-system process locale-coding-system 'utf-8)
    (set-process-sentinel process 'alert-pstoast--sentinel)
    (process-send-string process xml)
    (process-send-eof process)))

(defun alert-pstoast--sentinel (process status)
  "Show PowerShell script PROCESS STATUS."
  (message "pstoast: %s, %s, %s"
           (process-status process)
           (process-exit-status process)
           status))

(defun alert-pstoast-notify (info)
  "Notify notification INFO by PowerShell script."
  (let ((xml (alert-pstoast--xml
              (plist-get info :title)
              (plist-get info :message)
              (or (plist-get info :icon) alert-pstoast-default-icon))))
    (alert-pstoast--run-script xml)))

(alert-define-style 'pstoast :title "PowerShell toast notification script"
                    :notifier 'alert-pstoast-notify)

(provide 'alert-pstoast)
;;; alert-pstoast.el ends here
