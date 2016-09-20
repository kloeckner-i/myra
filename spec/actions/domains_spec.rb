# frozen_string_literal: true
require 'spec_helper'

describe Myra::Domains do
  let(:url) { 'https://api.myracloud.com/en/rapi/domains' }
  let(:forbidden_response) { { status: 403 } }
  let(:erroneous_response) { { status: 200, body: load_json('error') } }
  let!(:authorized_headers) do
    {
      'Date' => /.*/,
      'Authorization' => /MYRA\s.*/,
      'Content-Type' => 'application/json'
    }
  end
  let(:modified) { DateTime.parse '2013-12-09T11:30:00+0100' }

  let(:response) do
    {
      status: 200,
      body: load_json('successful_domain_creation')
    }
  end

  describe '.list' do
    let(:url) { 'https://api.myracloud.com/en/rapi/domains/1' }
    let!(:stub) do
      stub_request(:get, url).to_return(response)
    end

    describe 'successfully called' do
      let(:response) do
        {
          status: 200,
          body: load_json('successful_domains_response')
        }
      end
      it 'retrieves domains as list of objects' do
        domains = described_class.list
        expect(stub).to have_been_made.once
        expect(domains).to be_an Array
        expect(domains).to all(be_a(Myra::Domain))
        expect(domains.last.name).to eql 'nova.at'
        expect(domains.first.name).to eql 'foobar.rocks'
      end
    end

    describe 'unsucessfully called' do
      let(:response) { forbidden_response }
      it 'throws an error' do
        expect do
          described_class.list
        end.to raise_error(Myra::APIAuthError)
      end
    end

    describe 'page parameter' do
      let(:response) do
        {
          status: 200,
          body: load_json('successful_domains_response')
        }
      end
      let(:url) { 'https://api.myracloud.com/en/rapi/domains/42' }
      let!(:stub) do
        stub_request(:get, url).to_return(response)
      end
      it 'can use the page parameter' do
        domains = described_class.list(42)
        expect(stub).to have_been_made.once
      end
    end
  end

  describe '.create' do
    let!(:request) do
      stub_request(:put, url).with(
        headers: authorized_headers,
        body: {
          'name' => 'example.com',
          'autoUpdate' => false,
          'autoDns' => false,
          'maintenance' => false,
          'owned' => false,
          'paused' => false,
          'reversed' => false
        }
      ).to_return response
    end

    let(:domain) do
      domain = Myra::Domain.new
      domain.name = 'example.com'
      domain.auto_update = false
      domain.auto_dns = false
      domain
    end

    describe 'successfully called' do
      it 'creates a new domain' do
        created_domain = described_class.create(domain)
        expect(request).to have_been_made.once
        expect(created_domain.id).to eql 1
      end
    end

    describe 'unsucessfully called' do
      let(:response) { forbidden_response }
      it 'throws an error' do
        expect do
          described_class.create(domain)
        end.to raise_error(Myra::APIAuthError)
          .with_message(
            'Could not authenticate with the API, check your credentials'
          )
      end

      describe 'with violations' do
        let(:response) { erroneous_response }

        it 'throws an error with the violations parsed' do
          expect do
            described_class.create(domain)
          end.to raise_error(Myra::APIActionError)
        end

        it 'provides the violations as message' do
          begin
            described_class.create domain
          rescue Myra::APIActionError => e
            expect(e.violations).to be_an Array
            expect(e.violations).to all(be_a(Myra::Violation))
          end
        end
      end
    end
  end

  describe '.delete' do
    let!(:request) do
      stub_request(:delete, url).with(
        headers: authorized_headers,
        body: {
          'id' => 1,
          'modified' => modified.to_s
        }
      ).to_return(response)
    end

    let(:domain) do
      domain = Myra::Domain.new(id: 1)
      domain.modified = modified
      domain
    end

    describe 'successfully called' do
      it 'deletes an existing domain' do
        deleted_domain = described_class.delete(domain)
        expect(request).to have_been_made.once

        expect(deleted_domain).to be_a Myra::Domain
      end
    end

    describe 'unsucessfully called' do
      let(:response) { forbidden_response }
      it 'throws an error' do
        expect do
          described_class.delete(domain)
        end.to raise_error(Myra::APIAuthError)
      end

      describe 'with violations' do
        let(:response) { erroneous_response }

        it 'throws an error with the violations parsed' do
          expect do
            described_class.delete(domain)
          end.to raise_error(Myra::APIActionError)
        end

        it 'provides the violations as message' do
          begin
            described_class.delete domain
          rescue Myra::APIActionError => e
            expect(e.violations).to be_an Array
            expect(e.violations).to all(be_a(Myra::Violation))
          end
        end
      end
    end
  end

  describe '.update' do
    let(:response) do
      { status: 200, body: load_json('successful_domain_update') }
    end

    let(:domain) do
      dom = Myra::Domain.new(id: 15)
      dom.name = 'example.com'
      dom.modified = modified
      dom
    end

    let!(:request) do
      stub_request(:post, url).with(
        headers: authorized_headers,
        body: {
          'id' => 15,
          'modified' => modified.to_s,
          'autoUpdate' => true
        }
      ).to_return(response)
    end

    before(:each) do
      domain.auto_update = true

      # ignored
      domain.name = 'foobar.com'
      domain.owned = false
    end

    describe 'successfully called' do
      it 'updates the autoUpdate flag for the domain (and only this flag)' do
        updated = described_class.update(domain)

        expect(request).to have_been_made.once
        expect(updated).to be_a Myra::Domain
        expect(updated.name).to eql('example.com')
      end
    end

    describe 'unsucessfully called' do
      let(:response) { forbidden_response }
      it 'throws an error' do
        expect do
          described_class.update(domain)
        end.to raise_error(Myra::APIAuthError)
      end

      describe 'with violations' do
        let(:response) { erroneous_response }

        it 'throws an error with the violations parsed' do
          expect do
            described_class.update(domain)
          end.to raise_error(Myra::APIActionError)
        end

        it 'provides the violations as message' do
          begin
            described_class.update domain
          rescue Myra::APIActionError => e
            expect(e.violations).to be_an Array
            expect(e.violations).to all(be_a(Myra::Violation))
          end
        end
      end
    end
  end
end
