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

class Chef
  class Resource
    class HomebrewTap < Chef::Resource

      provides :homebrew_tap

      def initialize(name, run_context=nil)
        super
        @action = :tap
        @allowed_actions.push(:tap, :untap)
        @options = nil
        @resource_name = :homebrew_tap

        @name = name
        @homebrew_user = nil
      end

      def homebrew_user(arg=nil)
        set_or_return(
            :homebrew_user,
            arg,
            :kind_of => [ String, Integer ]
        )
      end

      def name(arg=nil)
        set_or_return(
            :name,
            arg,
            :kind_of => [ String, Array ]
        )
      end

    end
  end
end
