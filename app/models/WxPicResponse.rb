require 'WxBaseResponse'

class WxPicResponse< WxBaseResponse
  attr_accessor :ArticleCount, :Articles
  def to_xml
    super {|h|
      h[:ArticleCount] = @ArticleCount
      h[:Articles] = @Articles
      }
  end
end

class WxPicArticle
  attr_accessor :Title, :Description, :PicUrl, :Url
  def to_xml(options)
    options[:builder].item {|i|
      i.Title @Title
      i.Description @Description
      i.PicUrl @PicUrl
      i.Url @Url
      }
  end
end