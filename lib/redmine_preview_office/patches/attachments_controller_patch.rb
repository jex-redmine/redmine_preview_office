# frozen_string_literal: true

#
# Redmine plugin to preview a Microsoft Office attachment file
#
# Copyright © 2018 Stephan Wenzel <stephan.wenzel@drwpatent.de>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

module RedminePreviewOffice
  module Patches
    module AttachmentsControllerPatch
      def self.included(base)
        base.extend(ClassMethods)
        base.send(:prepend, InstancOverwriteMethods)
        base.class_eval do
          unloadable
          alias_method           :find_attachment_for_preview_office, :find_attachment
          before_action          :find_attachment_for_preview_office, only: [:preview_office]

          def preview_office
            if @attachment.is_office_doc? && preview = @attachment.preview_office(size: params[:size])
              if stale?(etag: preview)
                send_file preview,
                          filename: filename_for_content_disposition(preview),
                          type: 'application/pdf',
                          disposition: 'inline'
              end
            else
              # No thumbnail for the attachment or thumbnail could not be created
              head 404
            end # if
          end # def
        end # base
      end # self

      module InstancOverwriteMethods
        def show
          rendered = false
          respond_to do |format|
            format.html do
              if @attachment.is_office_doc?
                render action: 'office'
                rendered = true
              end
            end
            format.any {}
          end
          super unless rendered
        end # def
      end # module
    end # module
  end # module
end # module

unless AttachmentsController.included_modules.include?(RedminePreviewOffice::Patches::AttachmentsControllerPatch)
  AttachmentsController.send(:include, RedminePreviewOffice::Patches::AttachmentsControllerPatch)
end
