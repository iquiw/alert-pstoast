;;;; alert-pstoast-tests.el --- Tests for alert-pstoast
;;; Commentary:
;;; Code:
(require 'alert-pstoast)
(require 'ert)

(ert-deftest alert-pstoast-xml-generation-message-only ()
  "Test toast XML generation."
  (should (string= (alert-pstoast--xml nil "message")
                   "<toast>
  <visual>
    <binding template=\"ToastText01\">
      <text id=\"1\">message</text>
    </binding>
  </visual>
</toast>")))

(ert-deftest alert-pstoast-xml-generation-title-and-message ()
  "Test toast XML generation."
  (should (string= (alert-pstoast--xml "title" "message")
                   "<toast>
  <visual>
    <binding template=\"ToastText02\">
      <text id=\"1\">title</text>
      <text id=\"2\">message</text>
    </binding>
  </visual>
</toast>")))

(provide 'alert-pstoast-tests)
;;; alert-pstoast-tests.el ends here
