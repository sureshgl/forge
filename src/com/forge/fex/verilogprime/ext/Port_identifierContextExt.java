package com.forge.fex.verilogprime.ext;

import java.util.List;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Port_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Port_identifierContextExt extends AbstractBaseExt {

	public Port_identifierContextExt(Port_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Port_identifierContext getContext() {
		return (Port_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).port_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Port_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Port_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected void getPorts(List<String> ports) {
		ports.add(getFormattedText());
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