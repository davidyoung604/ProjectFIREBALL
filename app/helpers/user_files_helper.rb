module UserFilesHelper
  IMAGE_EXTENSIONS_EMBED = %w(bmp jpg jpeg png).freeze
  IMAGE_EXTENSIONS = IMAGE_EXTENSIONS_EMBED + %w(cr2 dng nef).freeze
  VIDEO_EXTENSIONS_EMBED = %w(mkv mov mp4).freeze
  VIDEO_EXTENSIONS = VIDEO_EXTENSIONS_EMBED + %w(avi flv mpeg mpg wmv).freeze

  IMAGE_EXTENSIONS_RUN_TIFF_PARSER = %w(arw cr2 dng nef tiff).freeze

  def embeddable_image_extension?(file)
    IMAGE_EXTENSIONS_EMBED.include? file.extension.name
  end

  def embeddable_video_extension?(file)
    VIDEO_EXTENSIONS_EMBED.include? file.extension.name
  end

  def get_embed_code(file)
    if embeddable_image_extension?(file)
      image_tag(stream_path(file), alt: file.name, class: 'fit-image')
    elsif embeddable_video_extension?(file)
      # TODO: video embedding *works* but loads the entire file into
      # memory on the server. attempting to stream a 1 GB file = bad.
      # disabling the embedding for now as we don't know how powerful
      # of a machine the server will be on

      # video_tag(stream_path(file), alt: file.name, controls: true)
      ''
    else
      ''
    end
  end

  def get_suggested_tags_file(file)
    # get blah from blah.txt (extension won't help with tag suggestions)
    base_file_name = File.basename(file.name, File.extname(file.name))
    get_suggested_tags(file.directory.name + File::SEPARATOR + base_file_name)
  end

  def format_metadata(tag_name, data)
    case tag_name
    when :ApertureValue
      "f/#{data[0].to_f / data[1]}"
    when :ExposureTime
      "#{data[0]}/#{data[1]}"
    when :FNumber
      "f/#{data[0].to_f / data[1]}"
    when :FocalLength
      "#{data[0] / data[1]} mm"
    else
      data
    end
  end

  def run_tiff_parser?(file)
    IMAGE_EXTENSIONS_RUN_TIFF_PARSER.include? file.extension.name
  end
end
