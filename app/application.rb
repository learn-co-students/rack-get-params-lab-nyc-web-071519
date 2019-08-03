class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      resp.write "Your cart is empty" if @@cart==[]
      resp.write cart
    elsif req.path.match(/add/)
      search_term = req.params['item']
      resp.write add(search_term)
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

  def cart
    @@cart.reduce('') do|str, cart_item|
      str + "\n#{cart_item}"
    end
  end

  def add (item)
    if @@items.include?(item)
      @@cart << item
      return "added #{item}"
    else
      return "We don't have that item"
    end
  end

end
