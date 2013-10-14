# encoding: utf-8
class Front::ProductsController < Front::BaseController 

  #before_filter :check_current_user, :only => [:my_favorite, :my_share_list]

  def show
    @product = Stage::Product.fetch(params[:id])
  end

  def index
  end

  def my_favorite
  end

  def my_favorite_api
    options = {
      page: params[:page],
      pagesize: 10,
      sourcetype: params[:sourcetype] || 1
    }
    result = API::Product.my_favorite(request, options)
    render :json => gen_data(result).to_json, callback: params[:callback] 
  end

  def my_share_list
    options = {
      page: params[:page],
      pagesize: 10,
      userid: 1
    }
    result = API::Product.my_share_list(request, options)
    render json: gen_share(result).to_json, callback: params[:callback]
  end

  protected

  def check_current_user
    if  current_user.blank?
      redirect_to login_path
    end
  end

  def gen_share(result)
    items = []
    result["data"]["items"].each do |item|
      image_info = item["resources"].first
      items << {
        title:     item["productname"],
        price:     item["price"],
        oriprice:  item["originprice"],
        likecount: item["likecount"],
        url:       "",
        image:     image_info.blank? ? "" : ApplicationController.helpers.middle_pic_url(image_info)
      }
    end
    result = result["data"].slice(:pageindex, :pagesize, :totalcount, :totalpaged)
    result[:datas] = items
    result
  end

  def gen_data(result)
    items = []
    result["data"]["items"].each do |item|
      image_info = item["resources"].first
      items << {
        title:     item["name"],
        price:     item["price"],
        oriprice:  item["price"],
        likecount: item["favorable"],
        url:       "",
        image:     image_info.blank? ? "" : ApplicationController.helpers.middle_pic_url(image_info)
      }
    end
    result = result["data"].slice(:pageindex, :pagesize, :totalcount, :totalpaged)
    result[:datas] = items
    result
  end

end
