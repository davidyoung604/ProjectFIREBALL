module ApplicationHelper
  # creates a list of links to anchors within the same page
  # iterates over targets: '<a href="#target.field">target.field</a>'
  # e.g. field = :name, targets = Extension.all
  def get_anchor_links(field, targets)
    targets.map { |t| link_to(t.send(field), anchor: t.send(field)) }
  end

  # generates the same output as its sister-method, but takes an array
  # of strings and an optional symbol to call on the strings for the
  # link text (e.g. :titleize). allows more direct specification of
  # anchor links within the page (e.g. based on div id)
  def get_anchor_links_raw(arr, method = :titleize)
    arr.map { |e| link_to(e.send(method), anchor: e) }
  end

  def get_suggested_tags(str)
    ignored_words = %w(a desktop home in of the users)
    ignored_regex = /^[-!$%^&*()_+|~=`{}\[\]:";'<>?,.\/]$/

    words = str.split(File::SEPARATOR).map { |seg| seg.split(' ') }.flatten
    words.reject do |word|
      ignored_words.include?(word.downcase) || ignored_regex.match(word)
    end.sort.uniq
  end
end
