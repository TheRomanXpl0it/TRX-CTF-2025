const codeInputs = document.querySelectorAll('.code-digit');

codeInputs.forEach((input, index) => {
    input.addEventListener('input', () => {
        if (input.value.length === 1 && index < codeInputs.length - 1) {
            codeInputs[index + 1].focus();
        }
    });

    input.addEventListener('keydown', (e) => {
        if (e.key === 'Backspace' && input.value === '' && index > 0) {
            codeInputs[index - 1].focus();
        }
    });
});

const nextBtn = document.getElementById('next-btn');
const step1 = document.getElementById('step-1');
const step2 = document.getElementById('step-2');
const form = document.getElementById('secret-form');
const secretInput = document.getElementById("secret-input");

nextBtn.addEventListener('click', () => {
    step1.classList.remove('active');
    step2.classList.add('active');
});

form.addEventListener('submit', (e) => {
    e.preventDefault();

    const code = Array.from(codeInputs).map(input => input.value).join('').toUpperCase();

    if (code.length === 6) {
        step1.classList.remove('active');
        step2.classList.add('active');
        if(secretInput.value){
            form.submit();
        }
    }
});