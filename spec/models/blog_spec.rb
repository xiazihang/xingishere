# encoding : utf-8
require 'rails_helper'

describe Blog do
  let(:user) { FactoryGirl.create(:user) }
  let(:blog_category) { FactoryGirl.create(:blog_category3) }

  before :each do
    @blog = FactoryGirl.create(:blog)
  end

  subject { @blog }

  it { should belong_to(:user) }
  it { should belong_to(:blog_category) }

  it { should have_many(:tags) }
  it { should have_many(:user_loves).dependent(:destroy).inverse_of(:blog).class_name('UserLove') }
  it { should have_many(:comments) }
  it { should have_many(:loved_users).through(:user_loves).source(:user) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:url_name) }
  it { should validate_presence_of(:seo_keyword) }
  it { should validate_presence_of(:blog_category_id) }

  it { should validate_uniqueness_of(:title) }
  it { should validate_uniqueness_of(:url_name) }

  describe '测试scope' do
    it 'scope published' do
      @blog = FactoryGirl.create(:unpublished_blog, user_id: user.id)
      expect(Blog.published.to_a).not_to include @blog
    end

    it 'scope keyword' do
      %w(rails文章1, ruby文章2, swift文章3).each_with_index do |s, index|
        FactoryGirl.create(:blog2, title: s, url_name: s, blog_category_id: index)
      end

      expect(Blog.published.keyword('文章').count).to eq 3
    end

    it 'scope category' do
      %w(rails文章1, ruby文章2, swift文章3).each do |s|
        FactoryGirl.create(:blog2, title: s, url_name: s, blog_category_id: blog_category.id)
      end

      expect(Blog.published.category(blog_category.id).count).to eq 3
    end
  end

  describe '类方法 class method' do
    it '#category_find' do
      %w(rails文章1, ruby文章2, swift文章3).each do |s|
        FactoryGirl.create(:blog2, title: s, url_name: s, blog_category_id: blog_category.id)
      end

      expect(Blog.published.category_find(blog_category.id).count).to eq 3
    end
  end
end
