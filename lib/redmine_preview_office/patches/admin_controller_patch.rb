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
    module AdminControllerPatch
      def self.included(base)
        base.send(:include, InstancOverwriteMethods)

        base.class_eval do
          unloadable
        end # base
      end # self

      module InstancOverwriteMethods
        def info
          super
          @checklist << [:text_libreoffice_available_for_preview_office, Redmine::Thumbnail.libreoffice_available?]
        end # def
      end # module
    end # module
  end # module
end # module

unless AdminController.included_modules.include?(RedminePreviewOffice::Patches::AdminControllerPatch)
  AdminController.send(:include, RedminePreviewOffice::Patches::AdminControllerPatch)
end
