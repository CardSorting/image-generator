# Create a default user first
default_user = User.create!(
  email: 'demo@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)

puts "Created default user: #{default_user.email}"

# Create some initial generations if none exist
['natural', 'artistic', 'cartoon', 'realistic'].each do |style|
  next if Generation.where(style: style).exists?
  
  sizes = Generation::SIZES.values
  10.times do
    Generation.create!(
      style: style,
      status: 'completed',
      prompt: "Sample #{style} generation",
      image_url: nil, # No actual image for seeds
      user: default_user,
      size: sizes.sample, # Random size from available options
      metadata: {
        tags: ['sample', style, 'seed-data'].join(',')
      }
    )
  end
end

puts "Updating social metrics..."

# Add seed data for social metrics
Generation.find_each do |gen|
  # Randomize some realistic social metrics
  gen.update!(
    views_count: rand(1000..50000),
    likes_count: rand(100..5000),
    bookmarks_count: rand(50..2000),
    shares_count: rand(20..1000),
    last_engagement_at: rand(1..30).days.ago,
    engagement_rate: rand(5.0..25.0).round(2),
    trending_score: rand(0..100).round(2)
  )
end

puts "Setting trending styles..."

# Set higher metrics for specific styles to show trends
['natural', 'artistic', 'cartoon', 'realistic'].each do |style|
  Generation.where(style: style).limit(5).each do |gen|
    gen.update!(
      views_count: rand(40000..100000),
      likes_count: rand(4000..20000),
      bookmarks_count: rand(1000..5000),
      shares_count: rand(500..2000),
      last_engagement_at: rand(1..7).days.ago,
      engagement_rate: rand(15.0..35.0).round(2),
      trending_score: rand(60..100).round(2)
    )
  end
end

puts "Seed data complete!"
