package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Variable_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Variable_identifierContextExt extends AbstractBaseExt {

	public Variable_identifierContextExt(Variable_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Variable_identifierContext getContext() {
		return (Variable_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).variable_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Variable_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Variable_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected String getVariableName() {
		return getFormattedText();
	}

	@Override
	protected Boolean isPortDeclared(String portName) {
		if (portName.equals(getFormattedText())) {
			return true;
		} else {
			return false;
		}
	}
}