# encoding: utf-8


require 'csv'
require 'net/http'

# The "postnummer" (zip-codes) csv-files comes from http://www.erikbolstad.no/postnummer-koordinatar/txt/

#THIS CHECK's IF THE REMOTE VERSION OF THE CSV FILE CAN BE LOADED#

uri = URI.parse('http://www.erikbolstad.no/postnummer-koordinatar/txt/postnummer.csv')
result = Net::HTTP.start(uri.host, uri.port) { |http| http.get(uri.path) }


#THIS DETERMINES WHETHER TO USE REMOTE VERSION OF CSV (IF THIS EXISTS) OR LOCAL COPY)
	unless result.code =="200"
		puts "USING LOCAL FILE"
		zipfile = File.open(File.join(File.dirname(__FILE__),'lib/postnummer.csv'))

	else 
		puts "USING REMOTE LIST"
		zipfile = result.body
	end



@zip_codes = CSV.parse(zipfile, { :col_sep => "\t" })
 
puts "What ZIP-code do you want to check?"
zipcode = gets.chomp.to_s

if zipcode.length == 4
	 municipality = @zip_codes.find {|row| row.first === zipcode}
	 unless municipality.nil?
	 	puts "======="
	 	print "ZIP-code belongs to: "
		puts municipality[7].capitalize
	 	puts "======="

	else
		puts "No municipality matching zip-code"
	end
else 
	puts "Not a valid zip-code"
end
