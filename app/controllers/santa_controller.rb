class SantaController < ApplicationController

	def index
		@santa_input ||= ""
		@santa_input = params[:santa_input] if params[:santa_input]
		@santa_result ||= ""
		@santa_result = params[:santa_result] if params[:santa_result]

		santa_input_ary = []
		@santa_input.split("\r\n").each do |input_line|
			santa_input_ary << input_line.split(",").map(&:strip)
		end
		
		prev_result_hash = {}
		@santa_result.split("\r\n").each do |prev_line|
			prev_ary = prev_line.split("=>").map(&:strip)
			prev_result_hash[prev_ary.first] = prev_ary.last
		end

		@santa_result = calc_santa(santa_input_ary, prev_result_hash)
	end

	private

	def calc_santa(santa_input, prev_result)
		result_hash = {}
		f_length = 0
		total_input_ary = santa_input.flatten
		total_input_ary.each do |key_elem|
			subtract_ary = [santa_input.select{|a| a.include?(key_elem)}, prev_result[key_elem], result_hash.map{|k,v| v}].flatten
			available_ary = total_input_ary - subtract_ary
			result_hash[key_elem] = available_ary.length > 0 ? available_ary[rand(0..(available_ary.length-1))] : nil
			f_length = key_elem.length if key_elem.length > f_length
		end
		str_data = ""
		result_hash.map{|k, v| str_data += (str_data.empty? ? "" : "\r\n") + k.ljust(f_length, " ") + " => " + v}
		str_data
	end

end
