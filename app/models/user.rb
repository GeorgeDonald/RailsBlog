require 'pry'

class User < ApplicationRecord
  has_secure_password
  validates :loginname, :password, presence: true
  validates :loginname, uniqueness: true
  validates :password, length: {in: 6..20}
  validates :loginname, length: {in: 6..20}
  has_many :blogs, dependent: :destroy
  has_many :comments, dependent: :destroy

  def initialize(args = nil)
    super
    if args != nil && args['image'] != nil
      fileobj = args['image']
      if fileobj.size > 0
        @image_file = fileobj
        self.image = unique_and_proper_filename(fileobj.original_filename)
      end
    end
  end

  # I copied the following code from:
  # https://stackoverflow.com/questions/22247582/rails-4-saving-images-in-database
  # and did some modifications
  def save_file
    if @image_file.content_type.slice(0,5) != 'image'
      return false
    end
    
    # Bilddatei save
    if !save_uploaded_file(@image_file, 'images', self.image)
      return false
    end
    true
  end

  def delete_file
    delete_uploaded_file('images',self.image)
  end

  private

  def unique_and_proper_filename(filename)
    Time.now.to_i.to_s + "_" + File.basename(filename)
  end

  def delete_uploaded_file(filepath,filename)
    complete_path = "#{Rails.public_path}/#{filepath}/#{filename}"
    begin
      File.delete(complete_path)
    rescue
    end
  end

  def save_uploaded_file(fileobj, filepath, filename)

    # Complete Path
    complete_path = "#{Rails.public_path}/#{filepath}"

    # if neccessary, create directory
    FileUtils.mkdir_p(complete_path) unless File.exists?(complete_path)

    # save data
    begin
      f = File.open(complete_path + "/" + filename, "wb")
      f.write(fileobj.read)
    rescue
      return false
    ensure
      f.close unless f.nil?
    end
    true
  end
end
