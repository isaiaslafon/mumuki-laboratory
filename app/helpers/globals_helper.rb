module GlobalsHelper
  def globals_tags
    %Q{
      <script type="text/javascript">
        window.mumukiLocale = #{raw Organization.current.locale_json};
        mumuki.locale = '#{Organization.current.locale}';
        moment.locale('#{Organization.current.locale}');

        mumuki.incognitoMode = #{incognito_mode?};

        mumuki.version = '#{Mumuki::Laboratory::VERSION}';
      </script>
    }.html_safe
  end
end
