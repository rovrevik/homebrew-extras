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
require 'chef/provider'
require 'chef/mixin/homebrew_user'

class Chef
  class Provider
    class Package
      class HomebrewTap < Chef::Provider

        provides :homebrew_tap

        include Chef::Mixin::HomebrewUser

        def load_current_resource
          @current_resource = Chef::Resource::HomebrewTap.new(new_resource.name)
          @current_resource.name(new_resource.name)
        end

        def action_tap()
          brew('tap', new_resource.options, @current_resource.name)
        end

        def action_untap()
          brew('untap', new_resource.options, @current_resource.name)
        end

        def brew(*args)
          get_response_from_command("brew #{args.join(' ')}")
        end

        private

        def get_response_from_command(command)
          homebrew_uid = find_homebrew_uid(new_resource.respond_to?(:homebrew_user) && new_resource.homebrew_user)
          homebrew_user = Etc.getpwuid(homebrew_uid)

          Chef::Log.debug "Executing '#{command}' as user '#{homebrew_user.name}'"
          output = shell_out!(command, :timeout => 1800, :user => homebrew_uid, :environment => { 'HOME' => homebrew_user.dir, 'RUBYOPT' => nil })
          output.stdout.chomp
        end

      end
    end
  end
end
