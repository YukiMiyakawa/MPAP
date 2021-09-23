class SearchesController < ApplicationController
  def search
    @range = params[:range]
    @tag_list= Tag.all.limit(6).sort {|a,b| b.post_tags.size <=> a.post_tags.size}
    @tweets = Tweet.all.order(created_at: :desc).page(params[:page]).per(10)

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
      @main_post_all = @main_posts
      @main_posts = @main_posts.order(created_at: :desc).page(params[:page]).per(8)
      @keywords = params[:keyword]
      @range = 1
      render template: "main_posts/index"

    # 記事複数タグ検索
    elsif @range == '2'
      keywords = params[:keyword].split(/[[:blank:]]+/).select(&:present?)

      @tags = Tag.where(name: keywords)
                                    #1)id列だけ取る    2)指定したタグを元にグルーピング 3)havingはグルーピングしたものに対して条件を書くときに使用する
                                                                                         #distinctは指定したタグをもとにグルーピングを紐解く
      @post_tags = PostTag.where(tag_id: @tags.pluck(:id)).group(:main_post_id).having("count(distinct tag_id)=?",@tags.size)
      @main_posts = MainPost.where(id: @post_tags.pluck(:main_post_id))
      @main_post_all = @main_posts
      @main_posts = @main_posts.order(created_at: :desc).page(params[:page]).per(8)
      @keywords = params[:keyword]
      @range = 2
      render template: "main_posts/index"

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
      @users = @users.page(params[:page]).per(6)
      render template: "users/index"

    # ユーザー音楽ジャンル & 使用楽器検索
    elsif @range == '4'
      @user_instruments = UserInstrument.where(instrument_id: params[:instrument_id])
      @user_music_genres = UserMusicGenre.where(music_genre_id: params[:music_genre_id])

      @instrument_user_id = @user_instruments.pluck(:user_id)
      @music_genre_user_id = @user_music_genres.pluck(:user_id)

      if params[:instrument_id].blank? && params[:music_genre_id].blank?

        @main_posts = MainPost.all
        @users = User.all
        @users = @users.page(params[:page]).per(6)
        render template: "users/index"

      elsif @instrument_user_id.empty?

        @users = User.find(@music_genre_user_id)
        @users = Kaminari.paginate_array(@users).page(params[:page]).per(6)
        render template: "users/index"

      elsif @music_genre_user_id.empty?

        @users = User.find(@instrument_user_id)
        @users = Kaminari.paginate_array(@users).page(params[:page]).per(6)
        render template: "users/index"

      else

        @user_id = @instrument_user_id & @music_genre_user_id
        @users = User.find(@user_id)
        @users = Kaminari.paginate_array(@users).page(params[:page]).per(6)
        render template: "users/index"

      end
    else

      @main_post_all = MainPost.all
      @main_posts = MainPost.all.order(created_at: :DESC).page(params[:page]).per(8)
      render template: "main_posts/index"

    end
  end

  def one_tag_search
    @tag = Tag.find(params[:id])
    @keywords = @tag.name
    @main_post_all = @tag.main_posts
    @main_posts = @tag.main_posts.page(params[:page]).per(8)
    @range = 2
    @tag_list= Tag.all.limit(6).sort {|a,b| b.post_tags.size <=> a.post_tags.size}
    @tweets = Tweet.all.order(created_at: :desc).page(params[:page]).per(10)
    render template: "main_posts/index"
  end

  def index_sort
    selection = params[:sort]
    @tag_list= Tag.all.limit(6).sort {|a,b| b.post_tags.size <=> a.post_tags.size}
    @main_posts = MainPost.all

    if selection == "new" || selection == "old"
      @main_post_all = @main_posts
      @main_posts = @main_posts.post_sort(selection).page(params[:page]).per(8)
    else
      @main_posts = @main_posts.post_sort(selection)
      @main_post_all = @main_posts
      @main_posts = Kaminari.paginate_array(@main_posts).page(params[:page]).per(8)
    end

    @tweets = Tweet.all.order(created_at: :desc).page(params[:page]).per(10)
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

    if selection == "new" || selection == "old"
      @main_post_all = @main_posts
      @main_posts = @main_posts.post_sort(selection).page(params[:page]).per(8)
    else
      @main_posts = @main_posts.post_sort(selection)
      @main_post_all = @main_posts
      @main_posts = Kaminari.paginate_array(@main_posts).page(params[:page]).per(8)
    end

    @keywords = params[:keyword]
    @tag_list= Tag.all.limit(6).sort {|a,b| b.post_tags.size <=> a.post_tags.size}
    @tweets = Tweet.all.order(created_at: :desc).page(params[:page]).per(10)
    render template: "main_posts/index"
  end

  def result_tag_sort
    selection = params[:sort]
    keywords = params[:keyword].split(/[[:blank:]]+/).select(&:present?)

    @tags = Tag.where(name: keywords)

    @post_tags = PostTag.where(tag_id: @tags.pluck(:id)).group(:main_post_id).having("count(distinct tag_id)=?",@tags.size)
    # @main_posts = MainPost.find(@post_tags.pluck(:main_post_id))
    # byebug
    #<ActiveRecord::Relation SQLを発行してDBをつなげる？　複数レコードを返すような検索を行ったときに帰ってくるインスタンスがwhere
    @main_posts = MainPost.where(id: @post_tags.pluck(:main_post_id))

    if selection == "new" || selection == "old"
      @main_post_all = @main_posts
      @main_posts = @main_posts.post_sort(selection).page(params[:page]).per(8)
    else
      # byebug
      @main_posts = @main_posts.post_sort(selection)
      @main_post_all = @main_posts
      @main_posts = Kaminari.paginate_array(@main_posts).page(params[:page]).per(8)
    end
    @keywords = params[:keyword]
    @tag_list= Tag.all.limit(6).sort {|a,b| b.post_tags.size <=> a.post_tags.size}
    @tweets = Tweet.all.order(created_at: :desc).page(params[:page]).per(10)
    @range = 2
    render template: "main_posts/index"
  end

end
