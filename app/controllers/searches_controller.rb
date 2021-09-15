class SearchesController < ApplicationController
  def search
    @range = params[:range]
    @tag_list= Tag.all

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
        @main_posts.where!("title NOT LIKE ?", "%#{keyword.delete_prefix('-')}%").order(created_at: :DESC)
      end
      @keywords = params[:keyword]

    # 記事複数タグ検索
    elsif @range == '2'
      keywords = params[:keyword].split(/[[:blank:]]+/).select(&:present?)

      @tags = Tag.where(name: keywords)
                                    #1)id列だけ取る    2)指定したタグを元にグルーピング 3)havingはグルーピングしたものに対して条件を書くときに使用する
                                                                                         #distinctは指定したタグをもとにグルーピングを紐解く
      @post_tags = PostTag.where(tag_id: @tags.pluck(:id)).group(:main_post_id).having("count(distinct tag_id)=?",@tags.size)
      @main_posts = MainPost.find(@post_tags.pluck(:main_post_id))

      @keywords = params[:keyword]

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
    selection = params[:sort]
    @main_posts = MainPost.sort(selection)
    @tag_list= Tag.all
    render template: "main_posts/index"
  end

  def result_sort
    selection = params[:sort]

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
    @main_posts = @main_posts.post_sort(selection)
    @keywords = params[:keyword]
    @tag_list= Tag.all
  end

  def result_tag_sort
    selection = params[:sort]
    keywords = params[:keyword].split(/[[:blank:]]+/).select(&:present?)

    @tags = Tag.where(name: keywords)

    @post_tags = PostTag.where(tag_id: @tags.pluck(:id)).group(:main_post_id).having("count(distinct tag_id)=?",@tags.size)
    @main_posts = MainPost.find(@post_tags.pluck(:main_post_id))
    @main_posts = @main_posts.post_sort(selection)
    @keywords = params[:keyword]
    @tag_list= Tag.all
  end

end
