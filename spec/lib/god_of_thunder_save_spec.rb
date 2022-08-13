# frozen_string_literal: true

require "fakefs/spec_helpers"

require_relative "../../lib/god_of_thunder_save.rb"

describe GodOfThunderSave do
  include FakeFS::SpecHelpers

  let(:save_game_path) { File.expand_path("spec/fixtures/SAVEGAM1.GOT") }
  subject(:god_of_thunder_save) { described_class.new(save_game_path) }

  around(:each) do |example|
    save_game_path

    FakeFS do
      FakeFS::FileSystem.clone(save_game_path)

      example.run
    end
  end

  describe "#attributes" do
    subject(:attributes) { god_of_thunder_save.attributes }

    it "returns a Hash of attributes" do
      should eq(
        name: "god_of_thunder_save",
        health: 150,
        magic: 0,
        jewels: 0,
        keys: 0,
        score: 0,
        enchanted_apple: false,
        lightning_power: false,
        winged_boots: false,
        wind_power: false,
        amulet_of_protection: false,
        thunder_power: false
      )
    end
  end

  describe "#path" do
    subject(:path) { god_of_thunder_save.path }

    it "returns the correct path" do
      should eq(save_game_path)
    end
  end

  describe "#write!" do
    subject(:write!) { god_of_thunder_save.write! }

    it "returns the GodOfThunderSave instance" do
      should be(god_of_thunder_save)
    end
  end

  describe "#read!" do
    subject(:read!) { god_of_thunder_save.read! }

    it "returns the GodOfThunderSave instance" do
      should be(god_of_thunder_save)
    end
  end

  context "for a written file" do
    let(:write!) { god_of_thunder_save.write! }

    subject(:file_data) do
      File.open(save_game_path) do |file|
        file.seek(pos)
        file.read(bytes)
      end
    end

    context "with a new name value" do
      let(:pos) { 0x00 }
      let(:bytes) { 22 }

      before(:each) do
        god_of_thunder_save.name = "some other name"
        write!
      end

      it { should eq("some other name\0\0\0\0\0\0\0") }
    end

    context "with a new health value" do
      let(:pos) { 0x63 }
      let(:bytes) { 1 }

      before(:each) do
        god_of_thunder_save.health = 130
        write!
      end

      it { should eq("\x82") }
    end

    context "with a new magic value" do
      let(:pos) { 0x64 }
      let(:bytes) { 1 }

      before(:each) do
        god_of_thunder_save.magic = 120
        write!
      end

      it { should eq("\x78") }
    end

    context "with a new jewels value" do
      let(:pos) { 0x65 }
      let(:bytes) { 2 }

      before(:each) do
        god_of_thunder_save.jewels = 420
        write!
      end

      it { should eq("\xa4\x01") }
    end

    context "with a new keys value" do
      let(:pos) { 0x67 }
      let(:bytes) { 1 }

      before(:each) do
        god_of_thunder_save.keys = 69
        write!
      end

      it { should eq("\x45") }
    end

    context "with a new score value" do
      let(:pos) { 0x70 }
      let(:bytes) { 4 }

      before(:each) do
        god_of_thunder_save.score = 31337
        write!
      end

      it { should eq("\x69\x7a\x00\x00") }
    end

    context "with a new enchanted_apple value" do
      let(:pos) { 0x69 }
      let(:bytes) { 1 }

      before(:each) do
        god_of_thunder_save.enchanted_apple = true
        write!
      end

      it { should eq("\x01") }
    end

    context "with a new lightning_power value" do
      let(:pos) { 0x69 }
      let(:bytes) { 1 }

      before(:each) do
        god_of_thunder_save.lightning_power = true
        write!
      end

      it { should eq("\x02") }
    end

    context "with a new winged_boots value" do
      let(:pos) { 0x69 }
      let(:bytes) { 1 }

      before(:each) do
        god_of_thunder_save.winged_boots = true
        write!
      end

      it { should eq("\x04") }
    end

    context "with a new wind_power value" do
      let(:pos) { 0x69 }
      let(:bytes) { 1 }

      before(:each) do
        god_of_thunder_save.wind_power = true
        write!
      end

      it { should eq("\x08") }
    end

    context "with a new amulet_of_protection value" do
      let(:pos) { 0x69 }
      let(:bytes) { 1 }

      before(:each) do
        god_of_thunder_save.amulet_of_protection = true
        write!
      end

      it { should eq("\x10") }
    end

    context "with a new thunder_power value" do
      let(:pos) { 0x69 }
      let(:bytes) { 1 }

      before(:each) do
        god_of_thunder_save.thunder_power = true
        write!
      end

      it { should eq("\x20") }
    end
  end

  context "for a read file" do
    subject(:file_data) do
      File.open(save_game_path) do |file|
        file.seek(pos)
        file.read(bytes)
      end
    end

    context "with a new name value" do
      let(:pos) { 0x00 }
      let(:bytes) { 22 }

      it { should eq("god_of_thunder_save\0\0\0") }
    end

    context "with a new health value" do
      let(:pos) { 0x63 }
      let(:bytes) { 1 }

      it { should eq("\x96") }
    end

    context "with a new magic value" do
      let(:pos) { 0x64 }
      let(:bytes) { 1 }

      it { should eq("\x00") }
    end

    context "with a new jewels value" do
      let(:pos) { 0x65 }
      let(:bytes) { 2 }

      it { should eq("\x00\x00") }
    end

    context "with a new keys value" do
      let(:pos) { 0x67 }
      let(:bytes) { 1 }

      it { should eq("\x00") }
    end

    context "with a new score value" do
      let(:pos) { 0x70 }
      let(:bytes) { 4 }

      it { should eq("\x00\x00\x00\x00") }
    end

    context "with a new enchanted_apple value" do
      let(:pos) { 0x69 }
      let(:bytes) { 1 }

      it { should eq("\x00") }
    end

    context "with a new lightning_power value" do
      let(:pos) { 0x69 }
      let(:bytes) { 1 }

      it { should eq("\x00") }
    end

    context "with a new winged_boots value" do
      let(:pos) { 0x69 }
      let(:bytes) { 1 }

      it { should eq("\x00") }
    end

    context "with a new wind_power value" do
      let(:pos) { 0x69 }
      let(:bytes) { 1 }

      it { should eq("\x00") }
    end

    context "with a new amulet_of_protection value" do
      let(:pos) { 0x69 }
      let(:bytes) { 1 }

      it { should eq("\x00") }
    end

    context "with a new thunder_power value" do
      let(:pos) { 0x69 }
      let(:bytes) { 1 }

      it { should eq("\x00") }
    end
  end
end
