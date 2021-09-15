class Search < ApplicationRecord
  
  def and_no_search(target)
    keywords = params[:keyword].split(/[[:blank:]]+/).select(&:present?)
    negative_keywords, positive_keywords =
    keywords.partition {|keyword| keyword.start_with?("-") }

    positive_keywords.each do |keyword|
      target = target.where("title LIKE ?", "%#{keyword}%")
    end

    negative_keywords.each do |keyword|
      target.where!("title NOT LIKE ?", "%#{keyword.delete_prefix('-')}%")
    end
  end
end
