class Note
  attr_accessor :text

  def initialize(options = {})
    @id         = options["id"]
    @text       = options["text"]
    @author     = options["author"]
    @created_at = options["noted_at"]
  end
end