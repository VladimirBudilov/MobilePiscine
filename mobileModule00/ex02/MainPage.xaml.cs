namespace ex02
{
    public partial class MainPage : ContentPage
    {
        public MainPage()
        {
            InitializeComponent();
        }

        private void OnButtonClicked(object sender, EventArgs e)
        {
            if (sender is Button button)
            {
                string buttonText = button.Text;
                System.Diagnostics.Debug.WriteLine($"Button pressed: {buttonText}");
            }
        }
    }
}