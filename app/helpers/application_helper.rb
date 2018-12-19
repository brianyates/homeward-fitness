module ApplicationHelper
	def cutoffs(cutoff_string)
		@c = cutoff_string.split(":")
		@t = @c[0].split(",")
		@p = @c[1].split(",")
		@t.each_with_index do |t, i|
			if i==0
				@string = '<li>Complete in under ' + pluralize((@t[i].to_i/60), "minute") + ' - <span class="text-bold">' + @p[i] + ' points</span></li>'
			else
				@string += '<li>Complete in under ' + pluralize((@t[i].to_i/60), "minute") + ' - <span class="text-bold">' + @p[i] + ' points</span></li>'
			end
		end
		@string += '<li>Complete in ' + pluralize((@t.last.to_i/60), "minute") + ' or more - <span class="text-bold">' + @p.last + ' points</span></li>'
		("<ul>"+ @string + "</ul>").html_safe
	end
	def minute_convert(seconds)
		@m = (seconds / 60)
		@s = seconds % 60
		if @m == 0
			pluralize(@s, "second")
		elsif @s == 0
			pluralize(@m, "minute")
		else
			"#{pluralize(@m, 'minute')}, #{pluralize(@s, 'second')}".html_safe
		end
	end
	def total_time(seconds)
		if seconds==0 || seconds.blank?
			return_string = "0 Seconds"
		else
			t = seconds
			mm, ss = t.divmod(60)
			hh, mm = mm.divmod(60)
			dd, hh = hh.divmod(24)
			units = ['day', 'hour', 'minute', 'second']
			values = [dd, hh, mm, ss]
			return_string = ""
			values.each_with_index do |v, i|
				return_string += "#{pluralize(v, units[i])}," unless v==0
			end
			return_string = return_string.split(",").join(", ")
		end
		return_string.html_safe
	end
		
	def unauthorized
		"<h3>You are not authorized to view this page</h3>".html_safe
	end
	def not_logged_in
		"<h3>You need to <a role='button' class='cursor-pointer login-toggle'>log in</a> to view this page</h3>".html_safe
	end
end
