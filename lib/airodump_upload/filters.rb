require 'airoparser/airoparser'

module AirodumpUpload  
  private
  @@logger=nil

  public
  
  # This method will be called by the framework when the user selects your 
  # plugin from the drop down list of the 'Import from file' dialog
  def self.import(params={})
    file_content = File.read( params[:file] ).strip
    plugin_author_name = Configuration.author
    category = Category.find_or_create_by_name(Configuration.category)
    @@logger = params.fetch(:logger, Rails.logger)
    @@logger.info{ 'Author: %s' % plugin_author_name }
    @@logger.info{ 'Category: %s' % category.inspect }
    @@logger.info{ 'Starting parsing..' }
    @parser = AiroParser.new(file_content)
    @@logger.info{ 'Parsed..' }
    category = Category.find_by_name( Configuration.category )
    parent = Node.create( :label => "#{ File.basename( params[:file] ) } - airodump-ng scan" )
    ap_node = Node.create( :label => "Access Points", :parent => parent )
	
    @parser.aps.each do |ap|
	@@logger.info{ 'Adding %s' % ap.essid }
        ap_info = ''
        ap_info << "\t\tSSID: %s\t\tMAC: %s\t\tEncryption: %s" % [ap.essid, ap.bssid, ap.privacy]
        Note.create(
            :node => ap_node,
            :author => plugin_author_name,
            :category_id => category,
            :text => ap_info
        )
    end

    client_node = Node.create( :label => "Wireless Clients", :parent => parent )
    @parser.clients.each do |client|
	@@logger.info{ 'Adding %s' % client.mac }
        client_info = ''
        client_info << "\t\tMAC: %s\t\tBSSID: %s\t\tProbed APs: %s" % [client.mac, client.bssid, client.probedessid]
        Note.create(
            :node => client_node,
            :author => plugin_author_name,
            :category_id => category,
            :text => client_info
        )
    end

    return true
    # TODO: do something with the contents of the file!
    # if you want to print out something to the screen or to the uploader 
    # interface use @@logger.info("Your message")
  end
end
