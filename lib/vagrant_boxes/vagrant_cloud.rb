module VagrantBoxes

  class VagrantCloud

    attr_accessor :username
    attr_accessor :access_token

    def initialize(username, access_token)
      @username = username
      @access_token = access_token
    end

    def box_get(name)
      request('get', "/box/#{username}/#{name}")
    end

    def box_create(name, description)
      box = {:name => name, :short_description => description, :description => description}
      request('post', '/boxes', {:box => box})
    end

    def box_update(name, description)
      box = {:short_description => description, :description => description}
      request('put', "/box/#{username}/#{name}", {:box => box})
    end

    def box_ensure(name, description)
      begin
        box = box_get(name)
      rescue RestClient::ResourceNotFound => e
        box = box_create(name, description)
      end
      if box['short_description'] != description || box['description_markdown'] != description
        box = box_update(name, description)
      end
      box
    end

    def box_delete(name)
      request('delete', "/box/#{username}/#{name}")
    end

    private

    def request(method, path, params = {})
      params[:access_token] = access_token
      arg = {:params => params}
      arg = params if ['post', 'put'].include? method # Weird rest_client api
      result = RestClient.send(method, url_base + path, arg)
      result = JSON.parse(result)
      errors = result['errors']
      raise "Vagrant Cloud returned error: #{errors}" if errors
      result
    end

    def url_base
      'https://vagrantcloud.com/api/v1'
    end

  end
end
