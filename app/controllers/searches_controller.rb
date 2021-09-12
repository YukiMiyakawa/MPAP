class SearchesController < ApplicationController
  def search
    @range = params[:range]
    # byebug
    if @range == '1'
      keywords = params[:keyword].split(/[[:blank:]]+/).select(&:present?)
      negative_keywords, positive_keywords =
      keywords.partition {|keyword| keyword.start_with?("-") }

      @main_posts = MainPost.all

      positive_keywords.each do |keyword|
        @main_posts = @main_posts.where("title LIKE ?", "%#{keyword}%")
      end

      negative_keywords.each do |keyword|
        @main_posts.where!("title NOT LIKE ?", "%#{keyword.delete_prefix('-')}%")
      end

    else
      @main_posts = MainPost.all
    end
  end

end
