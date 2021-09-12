class SearchesController < ApplicationController
  def search
    @range = params[:range]

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

    elsif @range == '2'

    elsif @range == '3'

      keywords = params[:keyword].split(/[[:blank:]]+/).select(&:present?)
      negative_keywords, positive_keywords =
      keywords.partition {|keyword| keyword.start_with?("-") }

      @users = User.all

      positive_keywords.each do |keyword|
        @users = @users.where("name LIKE ?", "%#{keyword}%")
      end

      negative_keywords.each do |keyword|
        @users.where!("name NOT LIKE ?", "%#{keyword.delete_prefix('-')}%")
      end

    else
      @main_posts = MainPost.all
    end
  end

  def sort_result
  end

end
