require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ZBar::Image do
  
  if !ZBar::JPEG.available?
    pending "JPEG support is not available in your copy of libzbar; skipping tests"
  elsif ZBar::JPEG.bugged?
    ZBar::JPEG.warn_once_if_bugged
    pending "JPEG support is broken in your copy of libzbar; skipping tests"
  else
    describe ".from_jpeg" do
      let(:jpeg_data) { read_file jpeg_file }
      subject { described_class.from_jpeg(jpeg_data) }
      context "given test.jpg" do
        let(:jpeg_file) { "test.jpg" }
      
        its(:width) { should == 480 }
        its(:height) { should == 240 }
      end
    end
  end

  describe ".from_pgm" do
    let(:pgm_data) { read_file pgm_file }
    let(:image) { described_class.from_pgm(pgm_data) }
    subject { image }
    
    context "given test.pgm" do
      let(:pgm_file) { "test.pgm" }
      
      its(:width) { should == 480 }
      its(:height) { should == 240 }
      
      describe "process" do
        it "delegates to the passed processor" do
          processor = double("processor")
          expected_result = Object.new
          expect(processor).to receive(:process).with(subject).and_return(expected_result)
        
          expect(subject.process(processor)).to eq(expected_result)
        end

        it "instantiates a new processor with no arguments" do
          processor = double("processor")
          expect(processor).to receive(:process)
          expect(ZBar::Processor).to receive(:new).with(no_args).and_return(processor)
          subject.process
        end

        it "instantiates a new processor with configuration" do
          config_hash = { :foo => :bar }
          processor = double("processor")
          expect(processor).to receive(:process)
          expect(ZBar::Processor).to receive(:new).with(config_hash).and_return(processor)
          subject.process(config_hash)
        end
      end
    end
  end
end
