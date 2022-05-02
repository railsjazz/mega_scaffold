class Attachment < ApplicationRecord
  belongs_to :company
  
  mount_uploader :attachment, AttachmentUploader
end
