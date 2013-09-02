require 'rubygems'
require 'json'

jsonConfig = "urls.json"

# Open JSON file for parsing
counter = 0
haml = ""
json_text = JSON.parse(IO.read(jsonConfig))
sorted_object = json_text.sort_by {|e| e["name"].downcase}    

def doRow
    <<-EOF
%div.row
    EOF
end

haml += doRow
sorted_object.each do |item|
    if counter > 2
        haml += doRow
        counter = 0
    end

    haml +=<<-EOF
    %div.span5
        %a{:name =>"#{item["name"].downcase.gsub(/[^ 0-9a-z]/, '').gsub(/\s+/, '-')}", :class => "anchor"}
        %h2

            #{item["name"]}
        %p
            %input{:type=>"text", :class=>"js-url-field", :value=>"#{item["url"]}", :readonly=>"readonly"}
            %button{:type=>"button", :onclick => "openLink('#{item["url"]}')"} open
    EOF
    counter+=1
end
indexFile = "views/index.haml"
if File.exist?(indexFile)
    File.delete(indexFile)
end
File.open(indexFile, "a+") { |f| f.write(haml) }

