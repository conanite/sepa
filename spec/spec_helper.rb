require 'sepa'

#
# Ruby 1.8 hashes are unordered, which results in xml tag attributes appearing in arbitrary order, so
# we can't just do a plain string compare of output.
# XmlHelper replaces <Document blah blah blah> with <Document>, and checks that the "blah blah blah"
# part is still correct
#
module XmlHelper
  XMLNSXSI = 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'
  XMLNS_02 = 'xmlns="urn:iso:std:iso:20022:tech:xsd:pain.008.001.02"'
  XSI_02   = 'xsi:schemaLocation="urn:iso:std:iso:20022:tech:xsd:pain.008.001.02 pain.008.001.02.xsd"'

  XMLNS_04 = 'xmlns="urn:iso:std:iso:20022:tech:xsd:pain.008.001.04"'
  XSI_04   = 'xsi:schemaLocation="urn:iso:std:iso:20022:tech:xsd:pain.008.001.04 pain.008.001.04.xsd"'

  DOCUMENT_TAG = /<Document [^>]+>/

  def check_doc_header_02 xml
    document_tag = xml.match(DOCUMENT_TAG).to_s
    document_tag.should include XMLNSXSI
    document_tag.should include XMLNS_02
    document_tag.should include XSI_02
    xml.sub(DOCUMENT_TAG, '<Document>')
  end

  def check_doc_header_04 xml
    document_tag = xml.match(DOCUMENT_TAG).to_s
    document_tag.should include XMLNSXSI
    document_tag.should include XMLNS_04
    document_tag.should include XSI_04
    xml.sub(DOCUMENT_TAG, '<Document>')
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.order = 'random'
  config.include XmlHelper
end
