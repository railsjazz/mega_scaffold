class Attachment < ApplicationRecord
  belongs_to :company
  
  mount_uploader :file, AttachmentUploader
end
