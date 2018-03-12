package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Name_of_instanceContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Name_of_instanceContextExt extends AbstractBaseExt {

	public Name_of_instanceContextExt(Name_of_instanceContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Name_of_instanceContext getContext() {
		return (Name_of_instanceContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).name_of_instance());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Name_of_instanceContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Name_of_instanceContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected String getInstanceName() {
		return getFormattedText();
	}
}