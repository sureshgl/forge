package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Interface_instance_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Interface_instance_identifierContextExt extends AbstractBaseExt {

	public Interface_instance_identifierContextExt(Interface_instance_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Interface_instance_identifierContext getContext() {
		return (Interface_instance_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).interface_instance_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Interface_instance_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Interface_instance_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}