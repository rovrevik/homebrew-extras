#
# Author:: Ryan Ovrevik (<rlo@ovrevik>)
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/provider/package'
require 'chef/resource/package'
require 'chef/resource/homebrew_package'

class Chef
  class Resource
    class HomebrewCaskPackage < Chef::Resource::HomebrewPackage

      identity_attr :package_name

      provides :homebrew_cask

      def initialize(name, run_context=nil)
        super
        @resource_name = :homebrew_cask
      end

    end
  end
end
