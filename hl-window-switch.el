;;; hl-window-switch.el --- Highlight point when switching windows -*- lexical-binding: t -*-

;; Copyright (C) 2021 Roni Kallio

;; Author: Roni Kallio <roni@kallio.app>
;; Created: 4 Jan 2021
;; Keywords: frames
;; URL: https://github.com/rkallio/hl-window-switch

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation, either version 3 of the License, or (at your option) any later
;; version.
;;
;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
;; details.
;;
;; The license text: <http://www.gnu.org/licenses/gpl-3.0.html>

;;; Commentary:
;;
;; Highlight point when switching windows.
;;
;;; Code:

(require 'pulse)

(defcustom hl-window-switch-pulse-face 'pulse-highlight-start-face
  "Face applied to pulse overlay when a buffer is switched to."
  :type 'face
  :group 'hl-window-switch)
(windowp nil)

(defcustom hl-window-switch-highlight-minibuffer nil
  "Whether to highlight minibuffer when switching to it."
  :type 'boolean
  :group 'hl-window-switch)

(defun hl-window-switch--highlight-line-of-point (&optional frame-or-window)
  "Highlight the location  that the point is on in FRAME-OR-WINDOW.
If FRAME-OR-WINDOW is a frame, pick the current buffer in the
selected window of that frame.  If FRAME-OR-WINDOW is a window,
pick the current buffer in that window.  If FRAME-OR-WINDOW is
omitted or nil, use the frame returned from function
`selected-frame'.  In case the buffer is a minibuffer, do not
apply highlighting."
  (let* ((frame (cond ((framep frame-or-window) frame-or-window)
                      ((windowp frame-or-window) (window-frame frame-or-window))
                      ((null frame-or-window) (selected-frame))
                      (t (signal 'wrong-type-argument frame-or-window))))
         (window (car (window-list frame)))
         (buffer (window-buffer window)))
    (when (or (not (minibufferp buffer)) hl-window-switch-highlight-minibuffer)
      (with-current-buffer buffer
        (pulse-momentary-highlight-one-line (point)
                                            hl-window-switch-pulse-face)))))

(defvar hl-window-switch--hooks '(window-selection-change-functions
                                  window-buffer-change-functions)
  "List of hooks that command `hl-window-switch-mode' applies a function to.")

;;;###autoload
(define-minor-mode hl-window-switch-mode
  "Toggle window switch highlighting."
  :require 'hl-window-switch
  :global t
  (let ((hook-function (if hl-window-switch-mode
                           #'add-hook
                         #'remove-hook)))
    (dolist (hook hl-window-switch--hooks)
      (funcall hook-function
               hook
               #'hl-window-switch--highlight-line-of-point))))

(provide 'hl-window-switch)
;;; hl-window-switch.el ends here
