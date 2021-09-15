class SearchesController < ApplicationController
  def search
    @range = params[:range]

    # 記事タイトルキーワード検索
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

    # 記事複数タグ検索
    elsif @range == '2'
      # byebug
      keywords = params[:keyword].split(/[[:blank:]]+/).select(&:present?)

      @tags = Tag.where(name: keywords)
      # @main_posts = MainPost.all
      # byebug
      # @tags.each do |tag|
      #   @main_posts = @main_posts.where(id: tag.post_tag.main_post_id)
      # end

    # ユーザー名検索
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

    # ユーザー音楽ジャンル & 使用楽器検索
    elsif @range == '4'
      @user_instruments = UserInstrument.where(instrument_id: params[:instrument_id])
      @user_music_genres = UserMusicGenre.where(music_genre_id: params[:music_genre_id])

      @instrument_user_id = @user_instruments.pluck(:user_id)
      @music_genre_user_id = @user_music_genres.pluck(:user_id)

      @user_id = @instrument_user_id & @music_genre_user_id
      @users = User.find(@user_id)
    else
      @main_posts = MainPost.all
      @users = User.all
    end
  end

  def one_tag_search
    @tag = Tag.find(params[:id])
    @main_posts = @tag.main_posts
    @tag_list= Tag.all
    render template: "main_posts/index"
  end

  def index_sort
    selection = params[:keyword]
    @main_posts = MainPost.sort(selection)
    @tag_list= Tag.all
    render template: "main_posts/index"
  end

end
