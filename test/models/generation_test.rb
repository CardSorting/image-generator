require "test_helper"

class GenerationTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @generation = Generation.new(
      user: @user,
      prompt: "a beautiful mountain landscape",
      style: "natural",
      size: Generation::SIZES['landscape']
    )
  end

  test "should be valid with valid attributes" do
    assert @generation.valid?
  end

  test "should belong to user" do
    assert_respond_to @generation, :user
    @generation.user = nil
    assert_not @generation.valid?
  end

  test "should require prompt" do
    @generation.prompt = nil
    assert_not @generation.valid?
    assert_includes @generation.errors[:prompt], "can't be blank"
  end

  test "prompt should not be too long" do
    @generation.prompt = "a" * 1001
    assert_not @generation.valid?
    assert_includes @generation.errors[:prompt], "is too long"
  end

  test "should require valid style" do
    @generation.style = nil
    assert_not @generation.valid?
    
    @generation.style = "invalid_style"
    assert_not @generation.valid?
    
    Generation::STYLES.each do |valid_style|
      @generation.style = valid_style
      assert @generation.valid?, "#{valid_style} should be valid"
    end
  end

  test "should require valid size" do
    @generation.size = nil
    assert_not @generation.valid?
    
    @generation.size = "invalid_size"
    assert_not @generation.valid?
    
    Generation::SIZES.values.each do |valid_size|
      @generation.size = valid_size
      assert @generation.valid?, "#{valid_size} should be valid"
    end
  end

  test "size_format should return correct format name" do
    Generation::SIZES.each do |format, size|
      @generation.size = size
      assert_equal format, @generation.size_format
    end
    
    @generation.size = "800x600"
    assert_equal "custom", @generation.size_format
  end

  test "dimensions should return width and height" do
    @generation.size = "1024x576"
    width, height = @generation.dimensions
    assert_equal 1024, width
    assert_equal 576, height
  end

  test "dimensions should handle invalid size" do
    @generation.size = nil
    assert_equal [nil, nil], @generation.dimensions
    
    @generation.size = "invalid"
    assert_equal [nil, nil], @generation.dimensions
  end

  test "width and height methods should return correct values" do
    @generation.size = "576x1024"
    assert_equal 576, @generation.width
    assert_equal 1024, @generation.height
  end

  test "should set default status on create" do
    @generation.save
    assert_equal Generation::STATUSES[:pending], @generation.status
  end

  test "should validate status" do
    @generation.status = "invalid_status"
    assert_not @generation.valid?
    
    Generation::STATUSES.values.each do |valid_status|
      @generation.status = valid_status
      assert @generation.valid?, "#{valid_status} should be valid"
    end
  end

  test "recent scope should order by created_at desc" do
    assert_equal Generation.recent.to_sql, Generation.order(created_at: :desc).to_sql
  end

  test "by_status scope should filter by status" do
    status = Generation::STATUSES[:pending]
    assert_equal Generation.by_status(status).to_sql, Generation.where(status: status).to_sql
  end
end
