module VagrantCloud

  class Version

    attr_accessor :box
    attr_accessor :number
    attr_accessor :data

    def initialize(box, number, data = nil)
      @box = box
      @number = number
      @data = data
    end

    def version
      data['version']
    end

    def description
      data['description_markdown']
    end

    def data
      @data ||= account.request('get', "/box/#{account.username}/#{box.name}/version/#{number}")
    end

    def update(description)
      version = {:description => description}
      @data = account.request('put', "/box/#{account.username}/#{box.name}/version/#{number}", {:version => version})
    end

    def delete
      account.request('delete', "/box/#{account.username}/#{box.name}/version/#{number}")
    end

    def release
      @data = account.request('put', "/box/#{account.username}/#{box.name}/version/#{number}/release")
    end

    def revoke
      @data = account.request('put', "/box/#{account.username}/#{box.name}/version/#{number}/revoke")
    end

    private

    def account
      box.account
    end

  end
end
