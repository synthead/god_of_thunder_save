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

  describe "VERSION" do
    subject(:version) { described_class::VERSION }

    it { should eq("0.1.0") }
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

  describe "#name" do
    subject(:name) { god_of_thunder_save.name }

    it { should eq("god_of_thunder_save") }
  end

  describe "#health" do
    subject(:health) { god_of_thunder_save.health }

    it { should eq(150) }
  end

  describe "#magic" do
    subject(:magic) { god_of_thunder_save.magic}

    it { should eq(0) }
  end

  describe "#jewels" do
    subject(:jewels) { god_of_thunder_save.jewels }

    it { should eq(0) }
  end

  describe "#keys" do
    subject(:keys) { god_of_thunder_save.keys }

    it { should eq(0) }
  end

  describe "#score" do
    subject(:score) { god_of_thunder_save.score }

    it { should eq(0) }
  end

  describe "#enchanted_apple" do
    subject(:enchanted_apple) { god_of_thunder_save.enchanted_apple }

    it { should eq(false) }
  end

  describe "#lightning_power" do
    subject(:lightning_power) { god_of_thunder_save.lightning_power }

    it { should eq(false) }
  end

  describe "#winged_boots" do
    subject(:winged_boots) { god_of_thunder_save.winged_boots }

    it { should eq(false) }
  end

  describe "#wind_power" do
    subject(:wind_power) { god_of_thunder_save.wind_power }

    it { should eq(false) }
  end

  describe "#amulet_of_protection" do
    subject(:amulet_of_protection) { god_of_thunder_save.amulet_of_protection }

    it { should eq(false) }
  end

  describe "#thunder_power" do
    subject(:thunder_power) { god_of_thunder_save.thunder_power }

    it { should eq(false) }
  end

  context "for a written file" do
    let(:write!) { god_of_thunder_save.write! }

    let!(:save_game_data_before) { File.read(save_game_path) }
    let(:save_game_data_after) { File.open(save_game_path) }

    subject(:save_game_data_changed) do
      save_game_data_before.each_char.each_with_object({}) do |byte_before, changes|
        pos = save_game_data_after.pos
        byte_after = save_game_data_after.readchar

        changes[pos] = byte_after if byte_before != byte_after
      end
    end

    it "does not alter game data when no attributes have changed" do
      should be_empty
    end

    context "with a new name value" do
      context "with a name shorter than 22 characters" do
        before(:each) do
          god_of_thunder_save.name = "some other name"
          write!
        end

        it "right-pads with null characters" do
          should eq(
            0x00 => "s",
            0x02 => "m",
            0x03 => "e",
            0x04 => " ",
            0x05 => "o",
            0x06 => "t",
            0x07 => "h",
            0x08 => "e",
            0x09 => "r",
            0x0a => " ",
            0x0b => "n",
            0x0c => "a",
            0x0d => "m",
            0x0e => "e",
            0x0f => "\0",
            0x10 => "\0",
            0x11 => "\0",
            0x12 => "\0",
          )
        end
      end

      context "with a name that has 22 characters" do
        before(:each) do
          god_of_thunder_save.name = "22 character name here"
          write!
        end

        it "uses the original name" do
          should eq(
            0x00 => "2",
            0x01 => "2",
            0x02 => " ",
            0x03 => "c",
            0x04 => "h",
            0x05 => "a",
            0x06 => "r",
            0x07 => "a",
            0x08 => "c",
            0x09 => "t",
            0x0a => "e",
            0x0b => "r",
            0x0c => " ",
            0x0d => "n",
            0x0e => "a",
            0x0f => "m",
            0x10 => "e",
            0x11 => " ",
            0x12 => "h",
            0x13 => "e",
            0x14 => "r",
            0x15 => "e"
          )
        end
      end

      context "with a name longer than 22 characters" do
        before(:each) do
          god_of_thunder_save.name = "a very long name to be truncated"
          write!
        end

        it "truncates to 22 characters" do
          should eq(
            0x00 => "a",
            0x01 => " ",
            0x02 => "v",
            0x03 => "e",
            0x04 => "r",
            0x05 => "y",
            0x06 => " ",
            0x07 => "l",
            0x08 => "o",
            0x09 => "n",
            0x0a => "g",
            0x0b => " ",
            0x0c => "n",
            0x0d => "a",
            0x0e => "m",
            0x0f => "e",
            0x10 => " ",
            0x11 => "t",
            0x12 => "o",
            0x13 => " ",
            0x14 => "b",
            0x15 => "e"
          )
        end
      end
    end

    context "with a new health value" do
      before(:each) do
        god_of_thunder_save.health = 130
        write!
      end

      it { should eq(0x63 => "\x82") }
    end

    context "with a new magic value" do
      before(:each) do
        god_of_thunder_save.magic = 120
        write!
      end

      it { should eq(0x64 => "\x78") }
    end

    context "with a new jewels value" do
      before(:each) do
        god_of_thunder_save.jewels = 420
        write!
      end

      it { should eq(0x65 => "\xa4", 0x66 => "\x01") }
    end

    context "with a new keys value" do
      before(:each) do
        god_of_thunder_save.keys = 69
        write!
      end

      it { should eq(0x67 => "\x45") }
    end

    context "with a new score value" do
      before(:each) do
        god_of_thunder_save.score = 31337
        write!
      end

      it { should eq(0x70 => "i", 0x71 => "z") }
    end

    context "with a new enchanted_apple value" do
      before(:each) do
        god_of_thunder_save.enchanted_apple = true
        write!
      end

      it { should eq(0x69 => "\x01") }
    end

    context "with a new lightning_power value" do
      before(:each) do
        god_of_thunder_save.lightning_power = true
        write!
      end

      it { should eq(0x69 => "\x02") }
    end

    context "with a new winged_boots value" do
      before(:each) do
        god_of_thunder_save.winged_boots = true
        write!
      end

      it { should eq(0x69 => "\x04") }
    end

    context "with a new wind_power value" do
      before(:each) do
        god_of_thunder_save.wind_power = true
        write!
      end

      it { should eq(0x69 => "\x08") }
    end

    context "with a new amulet_of_protection value" do
      before(:each) do
        god_of_thunder_save.amulet_of_protection = true
        write!
      end

      it { should eq(0x69 => "\x10") }
    end

    context "with a new thunder_power value" do
      before(:each) do
        god_of_thunder_save.thunder_power = true
        write!
      end

      it { should eq(0x69 => "\x20") }
    end
  end
end
