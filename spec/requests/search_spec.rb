require 'spec_helper'

describe 'Search page', type: :request do
  describe "search results" do
    before {
      allow(Section).to receive(:all).and_return([])
    }

    context 'exact match' do
      it 'should redirect user to exact match page' do
        VCR.use_cassette('tariff_updates#index') do
          VCR.use_cassette('geographical_areas#countries') do
            visit sections_path

            VCR.use_cassette('chapters#show') do
              VCR.use_cassette('search#search_exact') do
                within("#new_search") do
                  fill_in 't', with: '0101210000'
                  click_button 'Search'
                end

                expect(page).to have_content 'Pure-bred breeding animals'
                expect(page).to have_content 'The commodity code for importing is 0101210000.'
              end
            end
          end
        end
      end
    end

    context 'fuzzy match' do
      it 'returns result list' do
        VCR.use_cassette('tariff_updates#index') do
          VCR.use_cassette('geographical_areas#countries') do
            visit sections_path

            VCR.use_cassette('search#fuzzy_match') do
              within("#new_search") do
                fill_in 't', with: 'horses'
                click_button 'Search'
              end

              expect(page).to have_content 'Headings containing horses'
            end
          end
        end
      end
    end

    context 'no results found', vcr: { cassette_name: "search#blank_match" } do
      it 'should display no results message' do
        VCR.use_cassette('tariff_updates#index') do
          VCR.use_cassette('geographical_areas#countries') do
            visit sections_path

            within("#new_search") do
              fill_in 't', with: " !such string should not exist in the database! "
              click_button 'Search'
            end

            expect(page).to have_content 'There are no results matching your query'
          end
        end
      end
    end
  end

  describe "duplicate results" do
    before {
      VCR.use_cassette("search#duplicate_results") do
        visit perform_search_path(t: "synonym 1")
      end
    }

    let(:sections) { all("dt", text: "Section I") }

    it {
      expect(sections.count).to eq(1)
    }
  end
end
