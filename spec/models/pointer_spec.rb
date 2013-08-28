require "spec_helper"

describe Pointer do
  #it "orders by last name" do
  #  lindeman = User.create!(first_name: "Andy", last_name: "Lindeman")
  #  chelimsky = User.create!(first_name: "David", last_name: "Chelimsky")
  #
  #  expect(User.ordered_by_last_name).to eq([chelimsky, lindeman])
  #end

  let(:point) { Pointer.new(:latitude => 12.1234, :longitude => 23.456, :description => "desc1", :full_desc => "f_desc1", :rec_date => Date.today) }
  let(:duplicate_point) { Pointer.new(:latitude => 12.1234, :longitude => 23.456, :description => "desc1", :full_desc => "f_desc1", :rec_date => Date.today) }
  let(:near_point) { Pointer.new(:latitude => 12.1345, :longitude => 23.456, :description => "desc1", :full_desc => "f_desc1", :rec_date => Date.today) }
  let(:far_point) { Pointer.new(:latitude => 22.1234, :longitude => 23.456, :description => "desc1", :full_desc => "f_desc1", :rec_date => Date.today) }

  describe "Validations" do

    it "filter two ident coordinates" do
      point.save
      duplicate_point.save.should be_false
    end

  end


  describe "Finding points in radius" do

    before(:each) do
      point.save
      near_point.save
      far_point.save
    end

    it "should return an Array" do
      Pointer.search_in_radius(:radius => 2, :lat => 12.1239, :lng => 23.459).should be_kind_of Array
    end

    it "should return two points" do
      Pointer.search_in_radius(:radius => 5, :lat => 12.1239, :lng => 23.459).length.should == 2
    end

    it "should return tree points" do
      Pointer.search_in_radius(:radius => 0, :lat => 12.1239, :lng => 23.459).length.should == 3
    end

    it "should return tree points" do
      Pointer.search_in_radius(:radius => 1, :lat => 12.1239).length.should == 3
      Pointer.search_in_radius(:radius => 1, :lng => 23.459).length.should == 3
      Pointer.search_in_radius(:lat => 12.1239, :lng => 23.459).length.should == 3
    end

  end

  describe "selection by User" do

    before(:all) do
      @user = User.create(:email => "test@test.com", :password => "password", :password_confirmation => "password")
      point1 = Pointer.create(:latitude => 22.1234, :longitude => 23.456, :description => "desc1", :full_desc => "f_desc1", :rec_date => Date.today)
      point2 = Pointer.create(:latitude => 12.1234, :longitude => 23.456, :description => "desc2", :full_desc => "f_desc2", :rec_date => Date.today)
      point3 = Pointer.create(:latitude => 12.1345, :longitude => 23.456, :description => "desc3", :full_desc => "f_desc3", :rec_date => Date.today)
      point4 = Pointer.create(:latitude => 12.7654, :longitude => 23.456, :description => "desc3", :full_desc => "f_desc3", :rec_date => Date.today)
      Desire.create(:user_id => @user.id, :pointer_id => point1.id, :stat => 0)
      Desire.create(:user_id => @user.id, :pointer_id => point2.id, :stat => 1)
      Desire.create(:user_id => @user.id, :pointer_id => point3.id, :stat => 0)
      Desire.create(:user_id => 100, :pointer_id => point3.id, :stat => 1)
    end

    it "Should show all pointers if no user_id" do
      Pointer.select_pointers_by_user().size.should == 4
    end

    it "Should show all pointers if user_id not present and status presents" do
      Pointer.select_pointers_by_user(0, true, 1).size.should == 4
    end

    it "Should show all pointers if user_id but 'my' not present" do
      Pointer.select_pointers_by_user(@user.id).size.should == 4
    end

    it "Should show only users pointers if user_id and 'my' present" do
      Pointer.select_pointers_by_user(@user.id, true).size.should == 3
    end

    it "Should show only users pointers with status if user_id and status presents" do
      Pointer.select_pointers_by_user(@user.id, true, 1).size.should == 1
      Pointer.select_pointers_by_user(@user.id, true, 0).size.should == 2
    end


  end

end