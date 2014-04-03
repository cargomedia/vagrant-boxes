module VagrantCloud

  class Box

    attr_accessor :account
    attr_accessor :name
    attr_accessor :data

    def initialize(account, name, data = nil)
      @account = account
      @name = name
      @data = data
    end

    def description
      data['description_markdown']
    end

    def description_short
      data['short_description']
    end

    def data
      @data ||= account.request('get', "/box/#{account.username}/#{name}")
    end

    def update(description)
      box = {:short_description => description, :description => description}
      @data = account.request('put', "/box/#{account.username}/#{name}", {:box => box})
    end

    def delete
      account.request('delete', "/box/#{account.username}/#{name}")
    end

  end
end
