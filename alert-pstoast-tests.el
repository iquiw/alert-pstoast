;;;; alert-pstoast-tests.el --- Tests for alert-pstoast
;;; Commentary:
;;; Code:
(require 'alert-pstoast)
(require 'ert)

(ert-deftest alert-pstoast-xml-generation-message-only ()
  "Test toast XML generation."
  (should (string= (alert-pstoast--xml nil "message" nil)
                   "<toast>
  <visual>
    <binding template=\"ToastText01\">
      <text id=\"1\">message</text>
    </binding>
  </visual>
</toast>")))

(ert-deftest alert-pstoast-xml-generation-title-message ()
  "Test toast XML generation."
  (should (string= (alert-pstoast--xml "title" "message" nil)
                   "<toast>
  <visual>
    <binding template=\"ToastText02\">
      <text id=\"1\">title</text>
      <text id=\"2\">message</text>
    </binding>
  </visual>
</toast>")))

(ert-deftest alert-pstoast-xml-generation-message-icon ()
  "Test toast XML generation."
  (should (string= (alert-pstoast--xml nil "message" "image")
                   "<toast>
  <visual>
    <binding template=\"ToastImageAndText01\">
      <image id=\"1\" src=\"image\"/>
      <text id=\"1\">message</text>
    </binding>
  </visual>
</toast>")))

(ert-deftest alert-pstoast-xml-generation-title-message-icon ()
  "Test toast XML generation."
  (should (string= (alert-pstoast--xml "title" "message" "image")
                   "<toast>
  <visual>
    <binding template=\"ToastImageAndText02\">
      <image id=\"1\" src=\"image\"/>
      <text id=\"1\">title</text>
      <text id=\"2\">message</text>
    </binding>
  </visual>
</toast>")))

(provide 'alert-pstoast-tests)
;;; alert-pstoast-tests.el ends here
