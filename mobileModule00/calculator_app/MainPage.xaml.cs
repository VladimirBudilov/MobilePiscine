namespace calculator_app
{
    public partial class MainPage : ContentPage
    {
        private string _expression = string.Empty;

        public MainPage()
        {
            InitializeComponent();
        }

        private void OnButtonClicked(object sender, EventArgs e)
        {
            if (sender is Button button)
            {
                string buttonText = button.Text;
                _expression += buttonText;
                ExpressionLabel.Text = _expression;
            }
        }

        private void OnClearAllClicked(object sender, EventArgs e)
        {
            _expression = string.Empty;
            ExpressionLabel.Text = string.Empty;
            ResultLabel.Text = string.Empty;
        }

        private void OnClearClicked(object sender, EventArgs e)
        {
            if (_expression.Length > 0)
            {
                _expression = _expression.Substring(0, _expression.Length - 1);
                ExpressionLabel.Text = _expression;
            }
        }

        private void OnEqualClicked(object sender, EventArgs e)
        {
            try
            {
                var expression = new  NCalc.Expression(_expression);
                var result = expression.Evaluate();
                var roundedResult = Math.Round(Convert.ToDouble(result), 5);

                ResultLabel.Text = roundedResult.ToString();
            }
            catch (Exception)
            {
                ResultLabel.Text = "ufff.. chot slozna";
            }
        }
    }
}