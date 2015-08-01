#
# Author:: Ryan Ovrevik (<rlo@ovrevik>)
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'etc'
require 'chef/mixin/homebrew_user'

class Chef
  class Provider
    class Package
      class HomebrewCask < Chef::Provider::Package::Homebrew

        provides :homebrew_cask

        include Chef::Mixin::HomebrewUser

        def load_current_resource
          self.current_resource = Chef::Resource::HomebrewCaskPackage.new(new_resource.name)
          current_resource.package_name(new_resource.package_name)
          current_resource.version(current_installed_version)
          Chef::Log.debug("#{new_resource} current version is #{current_resource.version}") if current_resource.version

          @candidate_version = candidate_version

          Chef::Log.debug("#{new_resource} candidate version is #{@candidate_version}") if @candidate_version
        end

        def brew_info
          unless @brew_info
            output_lines = brew('info', new_resource.package_name).lines
            if output_lines[0].downcase.start_with?('error:')
              @brew_info = {'linked_keg' => nill}
            else
              candidate_version = output_lines[0].split[1]
              current_version = output_lines.any? {|l| l.downcase.include?('not installed')} ? nil : candidate_version
              @brew_info = {
                  'versions' => {
                      'stable' => candidate_version
                  },
                  'linked_keg' => current_version
              }
              @brew_info['linked_keg']
            end
          end
          @brew_info
        end

        def brew(*args)
          get_response_from_command(new_resource.extend_sudo_timeout_cmd) if new_resource.extend_sudo_timeout
          get_response_from_command("brew cask #{args.join(' ')}")
        end

      end
    end
  end
end
