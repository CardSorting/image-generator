module GenerationsHelper
  def sample_image_for_style(style)
    Generation.where(style: style, status: 'completed')
             .where.not(image_url: nil)
             .order(created_at: :desc)
             .first&.image_url
  end

  def style_stats(style)
    base_query = Generation.where(style: style)
    
    total_generations = base_query.count
    total_views = base_query.sum(:views_count)
    total_likes = base_query.sum(:likes_count)
    total_bookmarks = base_query.sum(:bookmarks_count)
    total_shares = base_query.sum(:shares_count)

    # Calculate average engagement rate
    avg_engagement = if total_views > 0
      ((total_likes + total_bookmarks + total_shares).to_f / total_views * 100).round(2)
    else
      0.0
    end

    # Calculate trending score based on recent engagement
    recent_engagement = base_query
      .where('last_engagement_at > ?', 24.hours.ago)
      .average(:trending_score).to_f.round(2)

    # Get popular tags
    popular_tags = base_query
      .where.not(metadata: nil)
      .where("metadata->>'tags' IS NOT NULL")
      .group("metadata->>'tags'")
      .order(Arel.sql('count(*) DESC'))
      .limit(3)
      .pluck(Arel.sql("metadata->>'tags'"))

    {
      total_generations: total_generations,
      total_views: total_views,
      total_likes: total_likes,
      total_bookmarks: total_bookmarks,
      total_shares: total_shares,
      engagement_rate: avg_engagement,
      trending_score: recent_engagement,
      popular_tags: popular_tags,
      popularity_score: calculate_popularity_score(total_views, avg_engagement, recent_engagement)
    }
  end

  private

  def calculate_popularity_score(views, engagement_rate, trending_score)
    return 0 if views == 0

    # Normalize views (cap at 10,000 for max score)
    normalized_views = [views / 10_000.0, 1].min * 40 # 40% weight

    # Normalize engagement rate (cap at 20% for max score)
    normalized_engagement = [engagement_rate / 20.0, 1].min * 40 # 40% weight

    # Normalize trending score (cap at 100 for max score)
    normalized_trending = [trending_score / 100.0, 1].min * 20 # 20% weight

    # Combine scores
    (normalized_views + normalized_engagement + normalized_trending).round
  end
end
