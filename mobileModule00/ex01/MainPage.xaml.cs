namespace ex01
{
    public partial class MainPage : ContentPage
    {
        private bool isHelloWorld = false;

        public MainPage()
        {
            InitializeComponent();
        }

        public void OnButtonClicked(object sender, EventArgs e)
        {
            if (isHelloWorld)
            {
                displayLabel.Text = "Initial Text";
            }
            else
            {
                displayLabel.Text = "Hello World!";
            }
            isHelloWorld = !isHelloWorld;
        }
    }

}
