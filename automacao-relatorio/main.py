from os import environ
from selenium import webdriver
from selenium.common import TimeoutException, ElementNotInteractableException
from selenium.webdriver import ActionChains, Keys
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from dotenv import load_dotenv
load_dotenv()

chrome_options = Options()
chrome_options.add_argument("--headless")
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)
driver.maximize_window()

commit_message = environ.get("COMMIT_MESSAGE")
commit_author = environ.get("COMMIT_AUTHOR")
commit_author_email = environ.get("COMMIT_AUTHOR_EMAIL")
commit_author_password = environ.get("COMMIT_AUTHOR_PASSWORD")
repository_name = environ.get("REPOSITORY_NAME").split('/')[1]
commit_url = environ.get("COMMIT_URL")

print(f"Autor: {commit_author}\n Email: {commit_author_email}\n Message: {commit_message}\n Repository: {repository_name}\n commit_url: {commit_url}")

driver.get('https://moodle.sptech.school/mod/quiz/view.php?id=30413')

def exceptions(func):
    try:
        return func()
    except TimeoutException:
        print("Timed out waiting for page to load")
    except ElementNotInteractableException:
        print("Element not interactable")
    except Exception as e:
        raise Exception(e)

def carregou_elemento_interativo(xpath:str):
    return exceptions(
        lambda: WebDriverWait(driver,30).until(
            EC.element_to_be_clickable((By.XPATH, xpath))
        )
    )

def carregou_elemento_interativo_css(selector:str):
    return exceptions(
        lambda: WebDriverWait(driver, 30).until(
            EC.element_to_be_clickable((By.CSS_SELECTOR, selector))
        )
    )

def carregou_elemento_com_texto(selector:str, text:str, time=3) -> webdriver:
    return exceptions(
        lambda: WebDriverWait(driver, time).until(
            EC.text_to_be_present_in_element((By.CSS_SELECTOR, selector), text)
        )
    )

def enviar_credenciais(email_autor:str, senha_autor:str):
    input_email = carregou_elemento_interativo_css('#username')
    input_email.clear()
    input_email.send_keys(email_autor)
    print('Email inserido')

    input_senha = carregou_elemento_interativo_css('#password')
    input_senha.clear()
    input_senha.send_keys(senha_autor)
    print('senha inserida')

    botao = carregou_elemento_interativo_css('#loginbtn')
    botao.click()


def login(email_autor:str, senha_autor:str) -> bool:
    for _ in range(1):
        enviar_credenciais(email_autor, senha_autor)

        login_realizado = carregou_elemento_com_texto(
            '#region-main > div:nth-child(2) > h3',
            'Resumo das suas tentativas anteriores')

        if login_realizado:
            return True
    return False

try:
    if login(commit_author_email, commit_author_password):
        print('login concluido com sucesso')
    else:
        raise Exception("Falha ao realizar o login")

    inicio_relatorio = carregou_elemento_interativo_css('#region-main > div:nth-child(2) > div.box.py-3.quizattempt > div')
    inicio_relatorio.click()
    print('iniciando relatório')

    grupo = carregou_elemento_interativo('/html/body/div[1]/div[3]/div/div/section[1]/div[1]/form/div/div[1]/div[2]/div/div[2]/div[2]/div[10]/input')
    grupo.click()
    print('grupo selecionado')

    proximo = carregou_elemento_interativo('/html/body/div[1]/div[3]/div/div/section[1]/div[1]/form/div/div[2]/input')
    proximo.click()
    print('indo para questão 2')

    explicacao = carregou_elemento_interativo('/html/body/div[2]/div[3]/div/div/section[1]/div[1]/form/div/div[1]/div[2]/div/div[2]/div[1]/div/div[1]/div/div[2]/div')
    escrever = ActionChains(driver)
    escrever.click(explicacao).key_down(Keys.CONTROL).send_keys('a').key_up(Keys.CONTROL).send_keys(Keys.DELETE).perform()
    escrever.send_keys(f'{repository_name}: {commit_message}').perform()
    print('explicando entrega')

    proximo = carregou_elemento_interativo('/html/body/div[2]/div[3]/div/div/section[1]/div[1]/form/div/div[2]/input[2]')
    proximo.click()
    print('indo para questão 3')

    explicacao = carregou_elemento_interativo('/html/body/div[2]/div[3]/div/div/section[1]/div[1]/form/div/div[1]/div[2]/div/div[2]/div[1]/div/div[1]/div/div[2]/div')
    escrever = ActionChains(driver)
    escrever.click(explicacao).key_down(Keys.CONTROL).send_keys('a').key_up(Keys.CONTROL).send_keys(Keys.DELETE).perform()
    escrever.send_keys(f'{commit_url}').perform()
    print('inserindo evidência')

    proximo = carregou_elemento_interativo('/html/body/div[2]/div[3]/div/div/section[1]/div[1]/form/div/div[2]/input[2]')
    proximo.click()
    print('indo para questão 4')

    explicacao = carregou_elemento_interativo('/html/body/div[2]/div[3]/div/div/section[1]/div[1]/form/div/div[1]/div[2]/div/div[2]/div[1]/div/div[1]/div/div[2]/div')
    escrever = ActionChains(driver)
    escrever.click(explicacao).key_down(Keys.CONTROL).send_keys('a').key_up(Keys.CONTROL).send_keys(Keys.DELETE).perform()

    if "frontend" in repository_name:
        mensagem = "React: desenvolvimento de telas"
    elif "backend" in repository_name:
        mensagem = "Spring boot: desenvolvimento do backend"
    elif "database" in repository_name:
        mensagem = "Mysql: desenvolvimento do banco de dados"
    else:
        mensagem = "terraform: desenvolvemento da infraestrutura"

    escrever.send_keys('Jira: Gestão do Projeto - Kanban').send_keys(Keys.ENTER).send_keys(f'{mensagem}').perform()
    print('respondendo questão 4')

    proximo = carregou_elemento_interativo('/html/body/div[2]/div[3]/div/div/section[1]/div[1]/form/div/div[2]/input[2]')
    proximo.click()
    print('indo para botão de conclusão')

    botao_envio = carregou_elemento_interativo('/html/body/div[1]/div[3]/div/div/section[1]/div[1]/div[3]/div/div/form/button')
    botao_envio.click()

    confirmar = carregou_elemento_interativo('/html/body/div[3]/div[3]/div/div[2]/div/div[2]/input[1]')
    confirmar.click()
    print('relatório realizado com sucesso!!!')

except Exception as e:
    raise Exception(f'Erro: {e}' )
finally:
    driver.quit()
