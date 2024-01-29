from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from jwt import encode
from functools import wraps
import awsgi
import os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('SQLALCHEMY_DATABASE_URI', 'postgresql://user:password@localhost:5432/db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = os.environ.get('SQLALCHEMY_TRACK_MODIFICATIONS', False)
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'sua_chave_secreta')

db = SQLAlchemy(app)

class Usuario(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    nome = db.Column(db.String)
    cpf = db.Column(db.String, unique=True)
    email = db.Column(db.String, unique=True)
    criado_em = db.Column(db.DateTime, default=datetime.utcnow)
    atualizado_em = db.Column(db.DateTime, default=datetime.utcnow)


def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')

        if not token:
            return jsonify({'message': 'Token está ausente!'}), 401

        try:
            data = decode(token, app.config['SECRET_KEY'])
            if data['id'] == 'anonimo':
                current_user = Usuario(id='anonimo')
            else:
                current_user = Usuario.query.get(data['id'])
        except:
            return jsonify({'message': 'Token é inválido!'}), 401

        return f(current_user, *args, **kwargs)

    return decorated


@app.route('/cadastro', methods=['POST'])
def cadastrar_usuario():
    data = request.get_json()

    try:
        novo_usuario = Usuario(
            nome=data['nome'],
            cpf=data['cpf'],
            email=data['email']
        )

        db.session.add(novo_usuario)
        db.session.commit()

        return jsonify({'message': 'Usuário cadastrado com sucesso!'})
    except Exception as e:
        return jsonify({'message': str(e)}), 500


@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()

    usuario = Usuario.query.filter_by(cpf=data['cpf']).first()

    if usuario:
        token = encode({'id': usuario.id}, app.config['SECRET_KEY'])
        return jsonify({'access_token': token})
    else:
        return jsonify({'message': 'Credenciais inválidas!'}), 401



@app.route('/login-anonimo', methods=['POST'])
def login_anonimo():
    token = encode({'id': 'anonimo'}, app.config['SECRET_KEY'])
    return jsonify({'access_token': token })

def lambda_handler(event, context):
    print('event', event)
    return awsgi.response(app, event, context, base64_content_types={"image/png"})

if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(debug=True, host='0.0.0.0', port=80)
